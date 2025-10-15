class Homework
{
    String subject;
    String title;
    DateTime deadline;
    bool isCompleted;

    Homework (
        {
            required this.subject,
            required this.title,
            required this.deadline,
            this.isCompleted = false,    
        }
    );
}