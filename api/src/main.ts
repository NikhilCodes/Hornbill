import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ConfigService } from '@nestjs/config';
import * as morgan from 'morgan';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get<ConfigService>(ConfigService);

  app.use(morgan('tiny')); // Logger
  app.setGlobalPrefix('api');
  await app.listen(configService.get('http.port'));
}

bootstrap();
