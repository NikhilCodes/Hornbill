import { Module } from '@nestjs/common';
import { MessagingGateway } from './messaging.gateway';

@Module({
  controllers: [],
  providers: [MessagingGateway],
})
export class MessagingModule {}
