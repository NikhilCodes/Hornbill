import { Module } from '@nestjs/common';
import { UserController } from './user.controller';
import { UserService } from './user.service';
import { UserRepository } from '../../core/repositories/user.repository';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserGateway } from './user.gateway';

@Module({
  imports: [TypeOrmModule.forFeature([UserRepository])],
  controllers: [UserController],
  providers: [UserService, UserGateway],
})
export class UserModule {}
