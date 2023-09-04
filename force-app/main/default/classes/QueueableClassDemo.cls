public with sharing class QueueableClassDemo implements Queueable {
    

public Contact contList;

public QueueableClassDemo(Contact con){
    contList = con;
}

public void execute(QueueableContext context){
    contList.FirstName = 'Queueable First Name Example';
    contList.LastName = 'Queueable Last Name Example';

    System.debug('queueable Example'+contList);
    update contList;

}


}