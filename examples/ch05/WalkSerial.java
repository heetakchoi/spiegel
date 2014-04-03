public class WalkSerial{
  public static void main(String[] args){
    WalkSerial ws = new WalkSerial();
    System.out.println("������ - �̻�");
    ws.action(13);
  }
  private void action(int size){
    System.out.printf("%d���Ǿ��ذ����θ������Ͽ�.\n", size);
    System.out.printf("(�������ٸ�����������Ͽ�.)\n\n");
    for(int i=0; i<size; i++){
      printMessage(i+1);
    }
  }
  private Object lock = new Object();
  private void printMessage(int index){
    synchronized(lock){
      try{
        lock.wait(1000L);
      }catch(InterruptedException e){
      }
      System.out.printf("��%d�Ǿ��ذ������ٰ�׸���.\n", index);
    }
  }
}
