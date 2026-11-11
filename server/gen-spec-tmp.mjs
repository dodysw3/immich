import { NestFactory } from '@nestjs/core';
import { ApiModule } from './dist/app.module.js';
import { useSwagger } from './dist/utils/misc.js';

process.env.DB_URL = process.env.DB_URL_OVERRIDE;
process.env.IMMICH_ENV = 'development';
process.env.TZ = 'UTC';

const sync = async () => {
  const app = await NestFactory.create(ApiModule, { preview: true });
  useSwagger(app, { write: true });
  await app.close();
};

sync()
  .then(() => {
    console.log('Done');
    process.exit(0);
  })
  .catch((error) => {
    console.error(error);
    console.log('Something went wrong');
    process.exit(1);
  });
