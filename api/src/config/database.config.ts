import { TypeOrmModuleOptions, TypeOrmOptionsFactory } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';
import { Injectable } from '@nestjs/common';

@Injectable()
export default class TypeOrmConfigService implements TypeOrmOptionsFactory {
  constructor(private configService: ConfigService) {}

  createTypeOrmOptions(): Promise<TypeOrmModuleOptions> | TypeOrmModuleOptions {
    return {
      type: 'postgres',
      host: this.configService.get('db.postgres.host'),
      port: this.configService.get('db.postgres.port'),
      username: this.configService.get('db.postgres.user'),
      password: this.configService.get('db.postgres.password'),
      database: this.configService.get('db.postgres.db_name'),
      autoLoadEntities: true,
      synchronize: true,
    };
  }
}
