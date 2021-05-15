import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { MessagingModule } from './modules/messaging/messaging.module';
import { UserModule } from './modules/user/user.module';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule } from '@nestjs/config';
import TypeOrmConfigService from './config/database.config';
import configuration from './config/configuration';
import { MulterModule } from '@nestjs/platform-express';
import { resolve } from 'path';
import { ChatRoomModule } from './modules/chat-room/chat-room.module';

@Module({
  imports: [
    MulterModule.register({
      dest: '../storage',
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useClass: TypeOrmConfigService,
    }),
    ConfigModule.forRoot({
      isGlobal: true,
      load: [configuration],
    }),
    MessagingModule,
    UserModule,
    ChatRoomModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer): any {
    consumer.apply();
  }
}
