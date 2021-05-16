/// <reference types="multer" />
import { CreateChatRoomDto } from '../../shared/dto/chat-room.dto';
import { ChatRoomService } from './chat-room.service';
import { ConfigService } from '@nestjs/config';
export declare class ChatRoomController {
    private chatRoomService;
    private configService;
    constructor(chatRoomService: ChatRoomService, configService: ConfigService);
    getChatRoomById(params: {
        roomId: string;
    }): Promise<import("./entities/chat-room.entity").default>;
    getChatRoomsByUserId(params: {
        userId: string;
    }): Promise<import("./entities/participation.entity").default[]>;
    createChatRoom(obj: CreateChatRoomDto): Promise<{
        name: string;
        imageUrl: string;
    } & import("./entities/chat-room.entity").default>;
    uploadGroupImage(file: Express.Multer.File): {
        filename: string;
        url: string;
    };
    viewUploadedGroupProfileImage(image: any, res: any): any;
}
