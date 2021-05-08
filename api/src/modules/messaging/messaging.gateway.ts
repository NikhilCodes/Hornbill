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

@WebSocketGateway({ namespace: 'messaging' })
export class MessagingGateway
  implements OnGatewayDisconnect, OnGatewayConnection {
  private readonly logger = new Logger(MessagingGateway.name);

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

  @SubscribeMessage('message.emit.server')
  handleMessage(client: Socket, payload: MessagePayloadDto): void {
    this.wss.to(payload.roomId).emit('message.emit.client', payload);
  }
}
