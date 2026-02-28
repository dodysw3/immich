import { mapAsset } from 'src/dtos/asset-response.dto';
import { AssetEditAction } from 'src/dtos/editing.dto';
import { AssetFaceFactory } from 'test/factories/asset-face.factory';
import { AssetFactory } from 'test/factories/asset.factory';
import { PersonFactory } from 'test/factories/person.factory';

describe('mapAsset', () => {
  describe('peopleWithFaces', () => {
    it('should include all faces for a person without applying edit-based coordinate transforms', () => {
      const person = PersonFactory.create();
      const face1 = {
        boundingBoxX1: 100,
        boundingBoxY1: 100,
        boundingBoxX2: 200,
        boundingBoxY2: 200,
        imageWidth: 1000,
        imageHeight: 800,
      };

      const face2 = {
        boundingBoxX1: 300,
        boundingBoxY1: 400,
        boundingBoxX2: 400,
        boundingBoxY2: 500,
        imageWidth: 1000,
        imageHeight: 800,
      };

      const asset = AssetFactory.from()
        .face(face1, (builder) => builder.person(person))
        .face(face2, (builder) => builder.person(person))
        .exif({ exifImageWidth: 1000, exifImageHeight: 800 })
        .edit({
          action: AssetEditAction.Crop,
          parameters: {
            width: 1512,
            height: 1152,
            x: 216,
            y: 1512,
          },
        })
        .build();

      const result = mapAsset(asset);

      expect(result.people).toBeDefined();
      expect(result.people).toHaveLength(1);
      expect(result.people![0].faces).toHaveLength(2);

      // mapAsset does not transform face coordinates; it returns stored face boxes.
      const firstFace = result.people![0].faces[0];
      const secondFace = result.people![0].faces[1];

      expect(firstFace.boundingBoxX1).toBe(100);
      expect(firstFace.boundingBoxY1).toBe(100);
      expect(firstFace.boundingBoxX2).toBe(200);
      expect(firstFace.boundingBoxY2).toBe(200);

      expect(secondFace.boundingBoxX1).toBe(300);
      expect(secondFace.boundingBoxY1).toBe(400);
      expect(secondFace.boundingBoxX2).toBe(400);
      expect(secondFace.boundingBoxY2).toBe(500);
    });

    it('should include unassigned faces without applying edit-based coordinate transforms', () => {
      const unassignedFace = AssetFaceFactory.create({
        boundingBoxX1: 100,
        boundingBoxY1: 100,
        boundingBoxX2: 200,
        boundingBoxY2: 200,
        imageWidth: 1000,
        imageHeight: 800,
      });

      const asset = AssetFactory.from()
        .face(unassignedFace)
        .exif({ exifImageWidth: 1000, exifImageHeight: 800 })
        .edit({ action: AssetEditAction.Crop, parameters: { x: 50, y: 50, width: 500, height: 400 } })
        .build();

      const result = mapAsset(asset);

      expect(result.unassignedFaces).toBeDefined();
      expect(result.unassignedFaces).toHaveLength(1);

      // mapAsset does not transform face coordinates; it returns stored face boxes.
      const face = result.unassignedFaces![0];
      expect(face.boundingBoxX1).toBe(100);
      expect(face.boundingBoxY1).toBe(100);
      expect(face.boundingBoxX2).toBe(200);
      expect(face.boundingBoxY2).toBe(200);
    });

    it('should handle multiple people each with multiple faces', () => {
      const person1Face1 = {
        boundingBoxX1: 100,
        boundingBoxY1: 100,
        boundingBoxX2: 200,
        boundingBoxY2: 200,
        imageWidth: 1000,
        imageHeight: 800,
      };

      const person1Face2 = {
        boundingBoxX1: 300,
        boundingBoxY1: 300,
        boundingBoxX2: 400,
        boundingBoxY2: 400,
        imageWidth: 1000,
        imageHeight: 800,
      };

      const person2Face1 = {
        boundingBoxX1: 500,
        boundingBoxY1: 100,
        boundingBoxX2: 600,
        boundingBoxY2: 200,
        imageWidth: 1000,
        imageHeight: 800,
      };

      const person = PersonFactory.create({ id: 'person-1' });

      const asset = AssetFactory.from()
        .face(person1Face1, (builder) => builder.person(person))
        .face(person1Face2, (builder) => builder.person(person))
        .face(person2Face1, (builder) => builder.person({ id: 'person-2' }))
        .exif({ exifImageWidth: 1000, exifImageHeight: 800 })
        .build();

      const result = mapAsset(asset);

      expect(result.people).toBeDefined();
      expect(result.people).toHaveLength(2);

      const person1 = result.people!.find((p) => p.id === 'person-1');
      const person2 = result.people!.find((p) => p.id === 'person-2');

      expect(person1).toBeDefined();
      expect(person1!.faces).toHaveLength(2);
      // No edits, so coordinates should be unchanged
      expect(person1!.faces[0].boundingBoxX1).toBe(100);
      expect(person1!.faces[0].boundingBoxY1).toBe(100);
      expect(person1!.faces[1].boundingBoxX1).toBe(300);
      expect(person1!.faces[1].boundingBoxY1).toBe(300);

      expect(person2).toBeDefined();
      expect(person2!.faces).toHaveLength(1);
      expect(person2!.faces[0].boundingBoxX1).toBe(500);
      expect(person2!.faces[0].boundingBoxY1).toBe(100);
    });

    it('should combine faces of the same person into a single entry', () => {
      const face1 = {
        boundingBoxX1: 100,
        boundingBoxY1: 100,
        boundingBoxX2: 200,
        boundingBoxY2: 200,
        imageWidth: 1000,
        imageHeight: 800,
      };

      const face2 = {
        boundingBoxX1: 300,
        boundingBoxY1: 300,
        boundingBoxX2: 400,
        boundingBoxY2: 400,
        imageWidth: 1000,
        imageHeight: 800,
      };

      const person = PersonFactory.create();

      const asset = AssetFactory.from()
        .face(face1, (builder) => builder.person(person))
        .face(face2, (builder) => builder.person(person))
        .exif({ exifImageWidth: 1000, exifImageHeight: 800 })
        .build();

      const result = mapAsset(asset);

      expect(result.people).toBeDefined();
      expect(result.people).toHaveLength(1);

      expect(result.people![0].id).toBe(person.id);
      expect(result.people![0].faces).toHaveLength(2);
    });
  });
});
