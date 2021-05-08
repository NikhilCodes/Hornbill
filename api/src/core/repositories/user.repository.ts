import { EntityRepository, Repository } from 'typeorm';
import UserEntity from '../../modules/user/entities/user.entity';

@EntityRepository(UserEntity)
export class UserRepository extends Repository<UserEntity> {}
