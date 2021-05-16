import { CreateUserDto, GetUserDto } from '../../shared/dto/user.dto';
import { UserRepository } from '../../core/repositories/user.repository';
export declare class UserService {
    private userRepository;
    constructor(userRepository: UserRepository);
    createUser(obj: CreateUserDto): Promise<CreateUserDto & import("./entities/user.entity").default>;
    loginExistingUser(phoneNumber: any): Promise<import("./entities/user.entity").default>;
    getUserById(obj: {
        userId: string;
    }): Promise<import("./entities/user.entity").default>;
    getUserByIdAndToken(obj: GetUserDto): Promise<import("./entities/user.entity").default>;
    getUserByPhoneNumber(phoneNumber: string): Promise<import("./entities/user.entity").default>;
}
