import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export default class ChatRoom {
  @PrimaryGeneratedColumn('uuid')
  public id: string;

  @Column({ nullable: false })
  name: string;

  @Column({ default: '' })
  description: string;

  @Column({ default: '' })
  imageUrl: string;
}
