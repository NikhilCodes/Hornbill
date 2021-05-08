import { EntityRepository, Repository } from 'typeorm';
import ParticipationEntity from '../../modules/chat-room/entities/participation.entity';

@EntityRepository(ParticipationEntity)
export class ParticipationRepository extends Repository<ParticipationEntity> {}
