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
var UserGateway_1;
Object.defineProperty(exports, "__esModule", { value: true });
exports.UserGateway = void 0;
const websockets_1 = require("@nestjs/websockets");
const common_1 = require("@nestjs/common");
const user_service_1 = require("./user.service");
let UserGateway = UserGateway_1 = class UserGateway {
    constructor(userService) {
        this.userService = userService;
        this.logger = new common_1.Logger(UserGateway_1.name);
    }
    handleConnection(client, ...args) {
        this.logger.verbose(`Client Connected: ${client.id}`);
    }
    handleDisconnect(client) {
        this.logger.verbose(`Client Disconnected: ${client.id}`);
    }
    async isPhoneNumberOfRegisteredUser(client, payload) {
        const foundUser = await this.userService.getUserByPhoneNumber(payload.phoneNumber);
        const result = {
            phoneNumber: payload.phoneNumber,
            isRegistered: foundUser !== undefined,
            avatarImageUrl: foundUser === null || foundUser === void 0 ? void 0 : foundUser.avatarImageUrl,
            name: foundUser === null || foundUser === void 0 ? void 0 : foundUser.username,
        };
        return {
            event: 'phone.check.isRegistered:result',
            data: result,
        };
    }
};
__decorate([
    websockets_1.WebSocketServer(),
    __metadata("design:type", Object)
], UserGateway.prototype, "wss", void 0);
__decorate([
    websockets_1.SubscribeMessage('phone.check.isRegistered'),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", Promise)
], UserGateway.prototype, "isPhoneNumberOfRegisteredUser", null);
UserGateway = UserGateway_1 = __decorate([
    websockets_1.WebSocketGateway(8001, { namespace: 'user' }),
    __metadata("design:paramtypes", [user_service_1.UserService])
], UserGateway);
exports.UserGateway = UserGateway;
//# sourceMappingURL=user.gateway.js.map