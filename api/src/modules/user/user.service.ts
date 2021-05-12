import { BadRequestException, Injectable } from '@nestjs/common';
import { CreateUserDto, GetUserDto } from '../../shared/dto/user.dto';
import { UserRepository } from '../../core/repositories/user.repository';
import { PHONE_NUMBER_REGEX, USERNAME_REGEX } from '../../shared/regex';

@Injectable()
export class UserService {
  constructor(private userRepository: UserRepository) {}

  createUser(obj: CreateUserDto) {
    if (!obj.username || !obj.phoneNumber) {
      throw new BadRequestException(
        'Must provide both `username` and `phoneNumber`.',
      );
    } else if (!USERNAME_REGEX.test(obj.username)) {
      throw new BadRequestException(
        `Invalid characters spotted in username: ${obj.username}.`,
      );
    } else if (!PHONE_NUMBER_REGEX.test(obj.phoneNumber)) {
      throw new BadRequestException('Invalid phone number.');
    }

    return this.userRepository.save(obj);
  }

  loginExistingUser(phoneNumber) {
    return this.userRepository.findOne({ where: { phoneNumber } });
  }

  getUserById(obj: { userId: string }) {
    return this.userRepository.findOne({
      where: { id: obj.userId },
      select: ['avatarImageUrl', 'phoneNumber', 'username', 'id'],
    });
  }

  getUserByIdAndToken(obj: GetUserDto) {
    return this.userRepository.findOne({
      where: obj,
    });
  }

  getUserByPhoneNumber(phoneNumber: string) {
    if (!PHONE_NUMBER_REGEX.test(phoneNumber)) {
      throw new BadRequestException(`Invalid phone number: ${phoneNumber}`);
    }

    return this.userRepository.findOne({ where: { phoneNumber } });
  }
}
