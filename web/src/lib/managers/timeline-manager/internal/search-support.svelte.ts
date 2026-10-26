import { AssetOrder, AssetOrderBy, type AssetResponseDto } from '@immich/sdk';
import { DateTime } from 'luxon';
import {
  getOrderingDate,
  plainDateTimeCompare,
  type TimelineDateTime,
  type TimelineYearMonth,
} from '$lib/utils/timeline-util';
import { TimelineManager } from '../timeline-manager.svelte';
import type { TimelineMonth } from '../timeline-month.svelte';
import type { AssetDescriptor, Direction, TimelineAsset } from '../types';

export async function getAssetWithOffset(
  timelineManager: TimelineManager,
  assetDescriptor: AssetDescriptor | AssetResponseDto,
  interval: 'asset' | 'day' | 'month' | 'year' = 'asset',
  direction: Direction,
): Promise<TimelineAsset | undefined> {
  const timelineMonth = await timelineManager.findTimelineMonthForAsset(assetDescriptor);
  if (!timelineMonth) {
    return;
  }
  const asset = timelineMonth.findAssetById(assetDescriptor);
  if (!asset) {
    return;
  }

  switch (interval) {
    case 'asset': {
      return getAssetByAssetOffset(timelineManager, asset, timelineMonth, direction);
    }
    case 'day': {
      return getAssetByDayOffset(timelineManager, asset, timelineMonth, direction);
    }
    case 'month': {
      return getAssetByMonthOffset(timelineManager, timelineMonth, direction);
    }
    case 'year': {
      return getAssetByYearOffset(timelineManager, timelineMonth, direction);
    }
  }
}

export function findTimelineMonthForAsset(timelineManager: TimelineManager, id: string) {
  for (const month of timelineManager.months) {
    const asset = month.findAssetById({ id });
    if (asset) {
      return { timelineMonth: month, asset };
    }
  }
}

export function getTimelineMonthByDate(
  timelineManager: TimelineManager,
  targetYearMonth: TimelineYearMonth,
): TimelineMonth | undefined {
  return timelineManager.months.find(
    (month) => month.yearMonth.year === targetYearMonth.year && month.yearMonth.month === targetYearMonth.month,
  );
}

async function getAssetByAssetOffset(
  timelineManager: TimelineManager,
  asset: TimelineAsset,
  timelineMonth: TimelineMonth,
  direction: Direction,
) {
  const timelineDay = timelineMonth.findTimelineDayForAsset(asset);
  for await (const targetAsset of timelineManager.assetsIterator({
    startTimelineMonth: timelineMonth,
    startTimelineDay: timelineDay,
    startAsset: asset,
    direction,
  })) {
    if (asset.id !== targetAsset.id) {
      return targetAsset;
    }
  }
}

async function getAssetByDayOffset(
  timelineManager: TimelineManager,
  asset: TimelineAsset,
  timelineMonth: TimelineMonth,
  direction: Direction,
) {
  const timelineDay = timelineMonth.findTimelineDayForAsset(asset);
  for await (const targetAsset of timelineManager.assetsIterator({
    startTimelineMonth: timelineMonth,
    startTimelineDay: timelineDay,
    startAsset: asset,
    direction,
  })) {
    if (targetAsset.localDateTime.day !== asset.localDateTime.day) {
      return targetAsset;
    }
  }
}

async function getAssetByMonthOffset(timelineManager: TimelineManager, month: TimelineMonth, direction: Direction) {
  for (const targetMonth of timelineManager.timelineMonthIterator({ startTimelineMonth: month, direction })) {
    if (targetMonth.yearMonth.month !== month.yearMonth.month) {
      const { value, done } = await timelineManager
        .assetsIterator({ startTimelineMonth: targetMonth, direction })
        .next();
      return done ? undefined : value;
    }
  }
}

async function getAssetByYearOffset(timelineManager: TimelineManager, month: TimelineMonth, direction: Direction) {
  for (const targetMonth of timelineManager.timelineMonthIterator({ startTimelineMonth: month, direction })) {
    if (targetMonth.yearMonth.year !== month.yearMonth.year) {
      const { value, done } = await timelineManager
        .assetsIterator({ startTimelineMonth: targetMonth, direction })
        .next();
      return done ? undefined : value;
    }
  }
}

// retrieveRange picks the walk direction by comparing the two endpoints, so this
// comparison must agree with the order the iterator actually yields: months and
// days are bucketed by the ordering date's calendar day, while assets within a
// day are sorted by fileCreatedAt with an id tie-break (timeline-day.sortAssets).
// Comparing the full ordering timestamp instead inverts the endpoints whenever
// two assets share a timestamp (or a day) but sort differently — the walk then
// never reaches the end asset and selects everything to the end of the timeline
// (upstream issue #23322). Positive ⇔ `a` comes first in iteration order.
function timelinePositionCompare(
  descending: boolean,
  orderBy: AssetOrderBy,
  a: TimelineAsset,
  b: TimelineAsset,
): number {
  const dayCompare = plainDateTimeCompare(
    descending,
    toCalendarDay(getOrderingDate(a, orderBy)),
    toCalendarDay(getOrderingDate(b, orderBy)),
  );
  if (dayCompare !== 0) {
    return dayCompare;
  }
  const fileCreatedCompare = plainDateTimeCompare(descending, a.fileCreatedAt, b.fileCreatedAt);
  if (fileCreatedCompare !== 0) {
    return fileCreatedCompare;
  }
  // Mirrors sortAssets' tie-break: smaller id first, regardless of direction.
  return a.id < b.id ? 1 : a.id > b.id ? -1 : 0;
}

function toCalendarDay(dateTime: TimelineDateTime): TimelineDateTime {
  return { ...dateTime, hour: 0, minute: 0, second: 0, millisecond: 0 };
}

const isMonthEarlierThan = (a: TimelineYearMonth, b: TimelineYearMonth) =>
  a.year < b.year || (a.year === b.year && a.month < b.month);

export async function retrieveRange(timelineManager: TimelineManager, start: AssetDescriptor, end: AssetDescriptor) {
  let { asset: startAsset, timelineMonth: startTimelineMonth } =
    findTimelineMonthForAsset(timelineManager, start.id) ?? {};
  if (!startTimelineMonth || !startAsset) {
    return [];
  }
  let { asset: endAsset, timelineMonth: endTimelineMonth } = findTimelineMonthForAsset(timelineManager, end.id) ?? {};
  if (!endTimelineMonth || !endAsset) {
    return [];
  }
  const startId = startAsset.id;
  const endId = endAsset.id;
  const startDay = startTimelineMonth.findTimelineDayForAsset(startAsset);
  const endDay = endTimelineMonth.findTimelineDayForAsset(endAsset);

  // When both endpoints share a day, resolve the range positionally from that
  // day's actual asset order. Endpoints tying on both the ordering date and
  // fileCreatedAt (e.g. cross-library duplicates) are ordered server-side by
  // originalFileName, which the bucket payload does not carry — and which is
  // arbitrary when even the names match — so no key comparison can predict
  // their order.
  if (startDay && startDay === endDay) {
    const assets = startDay.getAssets();
    const startIndex = assets.findIndex((asset) => asset.id === startId);
    const endIndex = assets.findIndex((asset) => asset.id === endId);
    if (startIndex !== -1 && endIndex !== -1) {
      const [from, to] = startIndex <= endIndex ? [startIndex, endIndex] : [endIndex, startIndex];
      return assets.slice(from, to + 1);
    }
  }

  const assetOrder: AssetOrder = timelineManager.getAssetOrder();
  const orderBy: AssetOrderBy = timelineManager.getOrderBy();
  let swapped = false;
  if (timelinePositionCompare(assetOrder === AssetOrder.Desc, orderBy, startAsset, endAsset) < 0) {
    [startAsset, endAsset] = [endAsset, startAsset];
    [startTimelineMonth, endTimelineMonth] = [endTimelineMonth, startTimelineMonth];
    swapped = true;
  }

  const range: TimelineAsset[] = [];
  let startTimelineDay = swapped ? endDay : startDay;
  for (const timelineMonth of timelineManager.timelineMonthIterator({ startTimelineMonth, direction: 'earlier' })) {
    // The walk goes toward earlier months, so once we pass the end asset's month
    // it can never be reached — a mis-decided direction above would otherwise
    // consume the rest of the timeline. Stop there instead; this caps the damage
    // at the end asset's month.
    if (isMonthEarlierThan(timelineMonth.yearMonth, endTimelineMonth.yearMonth)) {
      break;
    }
    await timelineManager.loadTimelineMonth(timelineMonth.yearMonth, { cancelable: false });
    for (const targetAsset of timelineMonth.assetsIterator({ startTimelineDay, startAsset, direction: 'earlier' })) {
      range.push(targetAsset);
      if (targetAsset.id === endAsset.id) {
        return range;
      }
    }
    startTimelineDay = undefined;
    startAsset = undefined;
  }
  return range;
}

export function findTimelineMonthForDate(timelineManager: TimelineManager, targetYearMonth: TimelineYearMonth) {
  for (const month of timelineManager.months) {
    const { year, month: monthNum } = month.yearMonth;
    if (monthNum === targetYearMonth.month && year === targetYearMonth.year) {
      return month;
    }
  }
}

export function findClosestTimelineMonthForDate(months: TimelineMonth[], targetYearMonth: TimelineYearMonth) {
  const targetDate = DateTime.fromObject({ year: targetYearMonth.year, month: targetYearMonth.month });

  let closestMonth: TimelineMonth | undefined;
  let minDifference = Number.MAX_SAFE_INTEGER;

  for (const month of months) {
    const monthDate = DateTime.fromObject({ year: month.yearMonth.year, month: month.yearMonth.month });
    const totalDiff = Math.abs(monthDate.diff(targetDate, 'months').months);

    if (totalDiff >= minDifference) {
      continue;
    }

    minDifference = totalDiff;
    closestMonth = month;
  }

  return closestMonth;
}
