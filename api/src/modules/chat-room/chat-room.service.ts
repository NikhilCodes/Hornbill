import { BadRequestException, Injectable } from '@nestjs/common';
import { CreateChatRoomDto } from '../../shared/dto/chat-room.dto';
import { ChatRoomRepository } from '../../core/repositories/chat-room.repository';
import { PHONE_NUMBER_REGEX } from '../../shared/regex';
import { ParticipationRepository } from '../../core/repositories/participation.repository';
import { UserService } from '../user/user.service';

@Injectable()
export class ChatRoomService {
  constructor(
    private chatRoomRepository: ChatRoomRepository,
    private participationRepository: ParticipationRepository,
    private userService: UserService,
  ) {}

  async createChatRoom(obj: CreateChatRoomDto) {
    const newlyCreatedChatRoom = await this.chatRoomRepository.save({
      name: obj.name,
      imageUrl: obj.imageUrl,
    });

    for (const phoneNumber of obj.usersToAddByPhoneNumber) {
      if (!PHONE_NUMBER_REGEX.test(phoneNumber)) {
        throw new BadRequestException('Invalid phone number.');
      }

      const participantId = (
        await this.userService.getUserByPhoneNumber(phoneNumber)
      ).id;

      await this.participationRepository.save({
        participantId,
        chatRoom: { id: newlyCreatedChatRoom.id },
      });
    }

    return newlyCreatedChatRoom;
  }

  async getChatRoomsByUserId(userId: string) {
    return this.participationRepository.find({
      relations: ['chatRoom'],
      // loadRelationIds: true,
      where: { participantId: userId },
    });
  }
}
