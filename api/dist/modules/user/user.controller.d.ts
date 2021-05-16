/// <reference types="multer" />
import { UserService } from './user.service';
import { CreateUserDto, GetUserDto } from '../../shared/dto/user.dto';
import { ConfigService } from '@nestjs/config';
export declare class UserController {
    private userService;
    private configService;
    constructor(userService: UserService, configService: ConfigService);
    getUserById(userId: any): Promise<import("./entities/user.entity").default>;
    createUser(obj: CreateUserDto): Promise<CreateUserDto & import("./entities/user.entity").default>;
    loginUser(obj: {
        phoneNumber: string;
    }): Promise<import("./entities/user.entity").default>;
    getUser(obj: GetUserDto): Promise<import("./entities/user.entity").default>;
    uploadAvatar(file: Express.Multer.File): {
        filename: string;
        url: string;
    };
    viewUploadedImage(image: any, res: any): any;
}
