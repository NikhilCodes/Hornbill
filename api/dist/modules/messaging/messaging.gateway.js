"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var MessagingGateway_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.MessagingGateway = void 0;
const websockets_1 = require("@nestjs/websockets");
const common_1 = require("@nestjs/common");
const user_service_1 = require("../user/user.service");
let MessagingGateway = MessagingGateway_1 = class MessagingGateway {
    constructor(userService) {
        this.userService = userService;
        this.logger = new common_1.Logger(MessagingGateway_1.name);
    }
    handleConnection(client, ...args) {
        this.logger.verbose(`Client Connected: ${client.id}`);
    }
    handleDisconnect(client) {
        this.logger.verbose(`Client Disconnected: ${client.id}`);
    }
    joinChatRoom(client, roomId) {
        client.join(roomId);
    }
    leaveChatRoom(client, roomId) {
        client.leave(roomId);
    }
    leaveAllChatRooms(client) {
        client.leaveAll();
    }
    async handleMessage(client, payload) {
        payload.time = new Date().toLocaleTimeString([], {
            hour: '2-digit',
            minute: '2-digit',
        });
        payload.senderName = (await this.userService.getUserById({ userId: payload.senderId })).username;
        this.wss.to(payload.roomId).emit('message.emit.client', payload);
    }
};
__decorate([
    websockets_1.WebSocketServer(),
    __metadata("design:type", Object)
], MessagingGateway.prototype, "wss", void 0);
__decorate([
    websockets_1.SubscribeMessage('room.join'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", void 0)
], MessagingGateway.prototype, "joinChatRoom", null);
__decorate([
    websockets_1.SubscribeMessage('room.leave'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", void 0)
], MessagingGateway.prototype, "leaveChatRoom", null);
__decorate([
    websockets_1.SubscribeMessage('room.leave.all'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], MessagingGateway.prototype, "leaveAllChatRooms", null);
__decorate([
    websockets_1.SubscribeMessage('message.emit.server'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], MessagingGateway.prototype, "handleMessage", null);
MessagingGateway = MessagingGateway_1 = __decorate([
    websockets_1.WebSocketGateway(81, { namespace: 'messaging' }),
    __metadata("design:paramtypes", [user_service_1.UserService])
], MessagingGateway);
exports.MessagingGateway = MessagingGateway;
//# sourceMappingURL=messaging.gateway.js.map