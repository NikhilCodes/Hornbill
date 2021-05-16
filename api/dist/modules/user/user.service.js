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
exports.UserService = void 0;
const common_1 = require("@nestjs/common");
const user_repository_1 = require("../../core/repositories/user.repository");
const regex_1 = require("../../shared/regex");
let UserService = class UserService {
    constructor(userRepository) {
        this.userRepository = userRepository;
    }
    createUser(obj) {
        if (!obj.username || !obj.phoneNumber) {
            throw new common_1.BadRequestException('Must provide both `username` and `phoneNumber`.');
        }
        else if (!regex_1.USERNAME_REGEX.test(obj.username)) {
            throw new common_1.BadRequestException(`Invalid characters spotted in username: ${obj.username}.`);
        }
        else if (!regex_1.PHONE_NUMBER_REGEX.test(obj.phoneNumber)) {
            throw new common_1.BadRequestException('Invalid phone number.');
        }
        return this.userRepository.save(obj);
    }
    loginExistingUser(phoneNumber) {
        return this.userRepository.findOne({ where: { phoneNumber } });
    }
    getUserById(obj) {
        return this.userRepository.findOne({
            where: { id: obj.userId },
            select: ['avatarImageUrl', 'phoneNumber', 'username', 'id'],
        });
    }
    getUserByIdAndToken(obj) {
        return this.userRepository.findOne({
            where: obj,
        });
    }
    getUserByPhoneNumber(phoneNumber) {
        if (!regex_1.PHONE_NUMBER_REGEX.test(phoneNumber)) {
            throw new common_1.BadRequestException(`Invalid phone number: ${phoneNumber}`);
        }
        return this.userRepository.findOne({ where: { phoneNumber } });
    }
};
UserService = __decorate([
    common_1.Injectable(),
    __metadata("design:paramtypes", [user_repository_1.UserRepository])
], UserService);
exports.UserService = UserService;
//# sourceMappingURL=user.service.js.map