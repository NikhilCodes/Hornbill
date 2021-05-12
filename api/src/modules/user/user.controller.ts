import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Res,
  UploadedFile,
  UseInterceptors,
} from '@nestjs/common';
import { UserService } from './user.service';
import { CreateUserDto, GetUserDto } from '../../shared/dto/user.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { ConfigService } from '@nestjs/config';

@Controller('user')
export class UserController {
  constructor(
    private userService: UserService,
    private configService: ConfigService,
  ) {}

  @Get(':userId')
  getUserById(@Param('userId') userId) {
    return this.userService.getUserById(userId);
  }

  @Post()
  createUser(@Body() obj: CreateUserDto) {
    return this.userService.createUser(obj);
  }

  @Post('login')
  loginUser(@Body() obj: { phoneNumber: string }) {
    return this.userService.loginExistingUser(obj.phoneNumber);
  }

  @Post('auto')
  getUser(@Body() obj: GetUserDto) {
    return this.userService.getUserByIdAndToken(obj);
  }

  @Post('avatar/upload')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: '../storage/avatars',
        filename: (req, file, cb) => {
          const randomName = Array(32)
            .fill(null)
            .map(() => Math.round(Math.random() * 16).toString(16))
            .join('');
          return cb(null, `${randomName}${extname(file.originalname)}`);
        },
      }),
    }),
  )
  uploadAvatar(@UploadedFile() file: Express.Multer.File) {
    return {
      filename: file.filename,
      url: `${this.configService.get('http.host')}${
        this.configService.get('production')
          ? ''
          : `:${this.configService.get('http.port')}`
      }/api/user/avatar/${file.filename}`,
    };
  }

  @Get('avatar/:id')
  viewUploadedImage(@Param('id') image, @Res() res) {
    return res.sendFile(image, { root: '../storage/avatars' });
  }
}
