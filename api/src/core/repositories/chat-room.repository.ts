import { EntityRepository, Repository } from 'typeorm';
import ChatRoomEntity from '../../modules/chat-room/entities/chat-room.entity';

@EntityRepository(ChatRoomEntity)
export class ChatRoomRepository extends Repository<ChatRoomEntity> {}
