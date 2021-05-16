import { OnGatewayConnection, OnGatewayDisconnect } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { MessagePayloadDto } from '../../shared/dto/messaging.dto';
import { UserService } from '../user/user.service';
export declare class MessagingGateway implements OnGatewayDisconnect, OnGatewayConnection {
    private userService;
    private readonly logger;
    constructor(userService: UserService);
    wss: Server;
    handleConnection(client: Socket, ...args: any[]): any;
    handleDisconnect(client: Socket): any;
    joinChatRoom(client: Socket, roomId: string): void;
    leaveChatRoom(client: Socket, roomId: string): void;
    leaveAllChatRooms(client: Socket): void;
    handleMessage(client: Socket, payload: MessagePayloadDto): Promise<void>;
}
