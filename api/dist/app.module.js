"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.AppModule = void 0;
const common_1 = require("@nestjs/common");
const messaging_module_1 = require("./modules/messaging/messaging.module");
const user_module_1 = require("./modules/user/user.module");
const typeorm_1 = require("@nestjs/typeorm");
const config_1 = require("@nestjs/config");
const database_config_1 = require("./config/database.config");
const configuration_1 = require("./config/configuration");
const platform_express_1 = require("@nestjs/platform-express");
const chat_room_module_1 = require("./modules/chat-room/chat-room.module");
let AppModule = class AppModule {
    configure(consumer) {
        consumer.apply();
    }
};
AppModule = __decorate([
    common_1.Module({
        imports: [
            platform_express_1.MulterModule.register({
                dest: '../storage',
            }),
            typeorm_1.TypeOrmModule.forRootAsync({
                imports: [config_1.ConfigModule],
                useClass: database_config_1.default,
            }),
            config_1.ConfigModule.forRoot({
                isGlobal: true,
                load: [configuration_1.default],
            }),
            messaging_module_1.MessagingModule,
            user_module_1.UserModule,
            chat_room_module_1.ChatRoomModule,
        ],
        controllers: [],
        providers: [],
    })
], AppModule);
exports.AppModule = AppModule;
//# sourceMappingURL=app.module.js.map