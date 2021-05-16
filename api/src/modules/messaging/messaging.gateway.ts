import {
  OnGatewayConnection,
  OnGatewayDisconnect,
  SubscribeMessage,
  WebSocketGateway,
  WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger } from '@nestjs/common';
import { MessagePayloadDto } from '../../shared/dto/messaging.dto';
import { UserService } from '../user/user.service';

@WebSocketGateway(81, { namespace: 'messaging' })
export class MessagingGateway
  implements OnGatewayDisconnect, OnGatewayConnection {
  private readonly logger = new Logger(MessagingGateway.name);

  constructor(private userService: UserService) {}

  @WebSocketServer()
  wss: Server;

  handleConnection(client: Socket, ...args: any[]): any {
    this.logger.verbose(`Client Connected: ${client.id}`);
  }

  handleDisconnect(client: Socket): any {
    this.logger.verbose(`Client Disconnected: ${client.id}`);
  }

  @SubscribeMessage('room.join')
  joinChatRoom(client: Socket, roomId: string) {
    client.join(roomId);
  }

  @SubscribeMessage('room.leave')
  leaveChatRoom(client: Socket, roomId: string) {
    client.leave(roomId);
  }

  @SubscribeMessage('room.leave.all')
  leaveAllChatRooms(client: Socket) {
    client.leaveAll();
  }

  @SubscribeMessage('message.emit.server')
  async handleMessage(client: Socket, payload: MessagePayloadDto) {
    payload.time = new Date().toLocaleTimeString([], {
      hour: '2-digit',
      minute: '2-digit',
    });
    payload.senderName = (
      await this.userService.getUserById({ userId: payload.senderId })
    ).username;
    this.wss.to(payload.roomId).emit('message.emit.client', payload);
  }
}
