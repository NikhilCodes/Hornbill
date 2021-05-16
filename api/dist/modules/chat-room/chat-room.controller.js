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
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ChatRoomController = void 0;
const common_1 = require("@nestjs/common");
const chat_room_service_1 = require("./chat-room.service");
const platform_express_1 = require("@nestjs/platform-express");
const multer_1 = require("multer");
const path_1 = require("path");
const config_1 = require("@nestjs/config");
let ChatRoomController = class ChatRoomController {
    constructor(chatRoomService, configService) {
        this.chatRoomService = chatRoomService;
        this.configService = configService;
    }
    getChatRoomById(params) {
        return this.chatRoomService.getChatRoomById(params.roomId);
    }
    getChatRoomsByUserId(params) {
        return this.chatRoomService.getChatRoomsByUserId(params.userId);
    }
    createChatRoom(obj) {
        obj.usersToAddByPhoneNumber = JSON.parse(obj.usersToAddByPhoneNumber);
        return this.chatRoomService.createChatRoom(obj);
    }
    uploadGroupImage(file) {
        return {
            filename: file.filename,
            url: `${this.configService.get('http.host')}:${this.configService.get('http.port')}/api/chat-room/group-profile-image/${file.filename}`,
        };
    }
    viewUploadedGroupProfileImage(image, res) {
        return res.sendFile(image, { root: '../storage/groupProfileImage' });
    }
};
__decorate([
    common_1.Get(':roomId'),
    __param(0, common_1.Param()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ChatRoomController.prototype, "getChatRoomById", null);
__decorate([
    common_1.Get('user/:userId'),
    __param(0, common_1.Param()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ChatRoomController.prototype, "getChatRoomsByUserId", null);
__decorate([
    common_1.Post(),
    __param(0, common_1.Body()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ChatRoomController.prototype, "createChatRoom", null);
__decorate([
    common_1.Post('group-profile-image/upload'),
    common_1.UseInterceptors(platform_express_1.FileInterceptor('file', {
        storage: multer_1.diskStorage({
            destination: '../storage/groupProfileImage',
            filename: (req, file, cb) => {
                const randomName = Array(32)
                    .fill(null)
                    .map(() => Math.round(Math.random() * 16).toString(16))
                    .join('');
                return cb(null, `${randomName}${path_1.extname(file.originalname)}`);
            },
        }),
    })),
    __param(0, common_1.UploadedFile()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", void 0)
], ChatRoomController.prototype, "uploadGroupImage", null);
__decorate([
    common_1.Get('group-profile-image/:id'),
    __param(0, common_1.Param('id')), __param(1, common_1.Res()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object]),
    __metadata("design:returntype", void 0)
], ChatRoomController.prototype, "viewUploadedGroupProfileImage", null);
ChatRoomController = __decorate([
    common_1.Controller('chat-room'),
    __metadata("design:paramtypes", [chat_room_service_1.ChatRoomService,
        config_1.ConfigService])
], ChatRoomController);
exports.ChatRoomController = ChatRoomController;
//# sourceMappingURL=chat-room.controller.js.map