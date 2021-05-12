import { Module } from '@nestjs/common';
import { MessagingGateway } from './messaging.gateway';
import { UserService } from '../user/user.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserRepository } from '../../core/repositories/user.repository';

@Module({
  imports: [TypeOrmModule.forFeature([UserRepository])],
  controllers: [],
  providers: [MessagingGateway, UserService],
})
export class MessagingModule {}
