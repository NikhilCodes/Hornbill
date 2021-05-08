import { Column, Entity, PrimaryGeneratedColumn } from 'typeorm';

@Entity()
export default class User {
  @PrimaryGeneratedColumn('uuid')
  public id: string;

  @Column()
  username: string;

  @Column({ unique: true })
  phoneNumber: string;

  @Column({ default: '' })
  avatarImageUrl: string;

  @Column({ generated: 'uuid' })
  token: string;
}
