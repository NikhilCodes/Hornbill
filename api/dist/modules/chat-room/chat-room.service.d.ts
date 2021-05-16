import { CreateChatRoomDto } from '../../shared/dto/chat-room.dto';
import { ChatRoomRepository } from '../../core/repositories/chat-room.repository';
import { ParticipationRepository } from '../../core/repositories/participation.repository';
import { UserService } from '../user/user.service';
export declare class ChatRoomService {
    private chatRoomRepository;
    private participationRepository;
    private userService;
    constructor(chatRoomRepository: ChatRoomRepository, participationRepository: ParticipationRepository, userService: UserService);
    createChatRoom(obj: CreateChatRoomDto): Promise<{
        name: string;
        imageUrl: string;
    } & import("./entities/chat-room.entity").default>;
    getChatRoomById(roomId: string): Promise<import("./entities/chat-room.entity").default>;
    getChatRoomsByUserId(userId: string): Promise<import("./entities/participation.entity").default[]>;
}
