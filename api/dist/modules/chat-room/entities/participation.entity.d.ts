import ChatRoom from './chat-room.entity';
export default class Participation {
    id: string;
    participantId: string;
    chatRoom: ChatRoom;
}
