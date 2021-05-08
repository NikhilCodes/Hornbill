import {
  Column,
  Entity,
  ManyToOne,
  OneToMany,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm';
import ChatRoom from './chat-room.entity';
import { JoinColumn } from 'typeorm';

@Entity()
export default class Participation {
  @PrimaryGeneratedColumn('uuid')
  public id: string;

  @Column()
  participantId: string;

  @ManyToOne(() => ChatRoom, (object) => object.id)
  @JoinColumn()
  chatRoom: ChatRoom;
}
