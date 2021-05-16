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
Object.defineProperty(exports, "__esModule", { value: true });
exports.ChatRoomService = void 0;
const common_1 = require("@nestjs/common");
const chat_room_repository_1 = require("../../core/repositories/chat-room.repository");
const regex_1 = require("../../shared/regex");
const participation_repository_1 = require("../../core/repositories/participation.repository");
const user_service_1 = require("../user/user.service");
let ChatRoomService = class ChatRoomService {
    constructor(chatRoomRepository, participationRepository, userService) {
        this.chatRoomRepository = chatRoomRepository;
        this.participationRepository = participationRepository;
        this.userService = userService;
    }
    async createChatRoom(obj) {
        const newlyCreatedChatRoom = await this.chatRoomRepository.save({
            name: obj.name,
            imageUrl: obj.imageUrl,
        });
        for (const phoneNumber of obj.usersToAddByPhoneNumber) {
            if (!regex_1.PHONE_NUMBER_REGEX.test(phoneNumber)) {
                throw new common_1.BadRequestException('Invalid phone number.');
            }
            const participantId = (await this.userService.getUserByPhoneNumber(phoneNumber)).id;
            await this.participationRepository.save({
                participantId,
                chatRoom: { id: newlyCreatedChatRoom.id },
            });
        }
        return newlyCreatedChatRoom;
    }
    async getChatRoomById(roomId) {
        return this.chatRoomRepository.findOne({
            where: {
                id: roomId,
            },
        });
    }
    async getChatRoomsByUserId(userId) {
        return this.participationRepository.find({
            relations: ['chatRoom'],
            where: { participantId: userId },
        });
    }
};
ChatRoomService = __decorate([
    common_1.Injectable(),
    __metadata("design:paramtypes", [chat_room_repository_1.ChatRoomRepository,
        participation_repository_1.ParticipationRepository,
        user_service_1.UserService])
], ChatRoomService);
exports.ChatRoomService = ChatRoomService;
//# sourceMappingURL=chat-room.service.js.map