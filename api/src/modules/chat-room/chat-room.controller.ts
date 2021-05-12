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
import { CreateChatRoomDto } from '../../shared/dto/chat-room.dto';
import { ChatRoomService } from './chat-room.service';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';
import { ConfigService } from '@nestjs/config';

@Controller('chat-room')
export class ChatRoomController {
  constructor(
    private chatRoomService: ChatRoomService,
    private configService: ConfigService,
  ) {}

  @Get(':roomId')
  getChatRoomById(@Param() params: { roomId: string }) {
    return this.chatRoomService.getChatRoomById(params.roomId);
  }

  @Get('user/:userId')
  getChatRoomsByUserId(@Param() params: { userId: string }) {
    return this.chatRoomService.getChatRoomsByUserId(params.userId);
  }

  @Post()
  createChatRoom(@Body() obj: CreateChatRoomDto) {
    obj.usersToAddByPhoneNumber = JSON.parse(
      obj.usersToAddByPhoneNumber as string,
    );
    return this.chatRoomService.createChatRoom(obj);
  }

  @Post('group-profile-image/upload')
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: '../storage/groupProfileImage',
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
  uploadGroupImage(@UploadedFile() file: Express.Multer.File) {
    return {
      filename: file.filename,
      url: `${this.configService.get('http.host')}${
        this.configService.get('production')
          ? ''
          : `:${this.configService.get('http.port')}`
      }/api/chat-room/group-profile-image/${file.filename}`,
    };
  }

  @Get('group-profile-image/:id')
  viewUploadedGroupProfileImage(@Param('id') image, @Res() res) {
    return res.sendFile(image, { root: '../storage/groupProfileImage' });
  }
}
