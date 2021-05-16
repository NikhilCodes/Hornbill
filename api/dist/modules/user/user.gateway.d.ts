import { OnGatewayConnection, OnGatewayDisconnect, WsResponse } from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ContactDto } from '../../shared/dto/user.dto';
import { UserService } from './user.service';
export declare class UserGateway implements OnGatewayConnection, OnGatewayDisconnect {
    private userService;
    private readonly logger;
    constructor(userService: UserService);
    wss: Server;
    handleConnection(client: Socket, ...args: any[]): any;
    handleDisconnect(client: Socket): any;
    isPhoneNumberOfRegisteredUser(client: Socket, payload: {
        phoneNumber: string;
    } | any): Promise<WsResponse<ContactDto>>;
}
