export interface CreateChatRoomDto {
  name: string;
  imageUrl: string;
  usersToAddByPhoneNumber: string[] | string;
}
