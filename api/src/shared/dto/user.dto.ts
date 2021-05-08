export interface CreateUserDto {
  username: string;
  phoneNumber: string;
  avatarImageUrl: string;
}

export interface GetUserDto {
  id: string;
  token: string;
}

export interface ContactDto {
  phoneNumber: string;
  name?: string;
  avatarImageUrl?: string;
  isRegistered: boolean;
}
