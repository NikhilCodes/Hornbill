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
const typeorm_1 = require("typeorm");
const chat_room_entity_1 = require("./chat-room.entity");
const typeorm_2 = require("typeorm");
let Participation = class Participation {
};
__decorate([
    typeorm_1.PrimaryGeneratedColumn('uuid'),
    __metadata("design:type", String)
], Participation.prototype, "id", void 0);
__decorate([
    typeorm_1.Column(),
    __metadata("design:type", String)
], Participation.prototype, "participantId", void 0);
__decorate([
    typeorm_1.ManyToOne(() => chat_room_entity_1.default, (object) => object.id),
    typeorm_2.JoinColumn(),
    __metadata("design:type", chat_room_entity_1.default)
], Participation.prototype, "chatRoom", void 0);
Participation = __decorate([
    typeorm_1.Entity()
], Participation);
exports.default = Participation;
//# sourceMappingURL=participation.entity.js.map