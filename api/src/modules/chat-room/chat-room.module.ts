import { Module } from '@nestjs/common';
import { ChatRoomController } from './chat-room.controller';
import { ChatRoomService } from './chat-room.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChatRoomRepository } from '../../core/repositories/chat-room.repository';
import { ParticipationRepository } from '../../core/repositories/participation.repository';
import { UserService } from '../user/user.service';
import { UserRepository } from '../../core/repositories/user.repository';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      ChatRoomRepository,
      ParticipationRepository,
      UserRepository,
    ]),
  ],
  controllers: [ChatRoomController],
  providers: [ChatRoomService, UserService],
})
export class ChatRoomModule {}
