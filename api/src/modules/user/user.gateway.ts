import {
  OnGatewayConnection,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
  WsResponse,
} from '@nestjs/websockets';
import { Logger } from '@nestjs/common';
import { Server, Socket } from 'socket.io';
import { ContactDto } from '../../shared/dto/user.dto';
import { UserService } from './user.service';

@WebSocketGateway(8001, { namespace: 'user' })
export class UserGateway implements OnGatewayConnection, OnGatewayDisconnect {
  private readonly logger = new Logger(UserGateway.name);

  constructor(private userService: UserService) {}

  @WebSocketServer()
  wss: Server;

  handleConnection(client: Socket, ...args: any[]): any {
    this.logger.verbose(`Client Connected: ${client.id}`);
  }

  handleDisconnect(client: Socket): any {
    this.logger.verbose(`Client Disconnected: ${client.id}`);
  }

  @SubscribeMessage('phone.check.isRegistered')
  async isPhoneNumberOfRegisteredUser(
    client: Socket,
    payload: { phoneNumber: string } | any,
  ): Promise<WsResponse<ContactDto>> {
    const foundUser = await this.userService.getUserByPhoneNumber(
      payload.phoneNumber,
    );

    const result: ContactDto = {
      phoneNumber: payload.phoneNumber,
      isRegistered: foundUser !== undefined,
      avatarImageUrl: foundUser?.avatarImageUrl,
      name: foundUser?.username,
    };

    return {
      event: 'phone.check.isRegistered:result',
      data: result,
    };
  }
}
