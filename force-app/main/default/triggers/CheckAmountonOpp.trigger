trigger CheckAmountonOpp on Opportunity (Before Insert, Before Update) {
    op_trigger_class.op_amount_check(Trigger.New);
}