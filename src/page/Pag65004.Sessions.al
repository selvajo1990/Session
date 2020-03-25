page 65004 "Sessions"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Active Session";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Sessions)
            {
                field("Client Computer Name"; "Client Computer Name")
                {
                    ApplicationArea = All;
                }
                field("Client Type"; "Client Type")
                {
                    ApplicationArea = All;
                }
                field("Database Name"; "Database Name")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field("Login Datetime"; "Login Datetime")
                {
                    ApplicationArea = All;
                }
                field("Server Instance Name"; "Server Instance Name")
                {
                    ApplicationArea = All;
                }
                field("Session ID"; "Session ID")
                {
                    ApplicationArea = All;
                }
                field("Server Instance ID"; "Server Instance ID")
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("Kill Selected Session")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Delete;
                trigger OnAction();
                begin
                    if not Confirm(StrSubstNo(SelectedSessionQst, Rec."Session ID")) then
                        exit;

                    StopSession("Session ID");
                end;
            }
            action("Kill Session Chain")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Cancel;
                trigger OnAction();
                begin
                    if not Confirm(StrSubstNo(SelectedSessionChainQst, Rec."Session ID")) then
                        exit;

                    SessionG.SetRange("User ID", "User ID");
                    if SessionG.FindSet() then
                        repeat
                            StopSession(SessionG."Session ID");
                        until SessionG.Next() = 0;
                end;
            }
            action("Kill All Session")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = CancelAllLines;
                trigger onaction()
                begin
                    if not Confirm(AllSessionQst) then
                        EXIT;

                    SessionG.SetFilter("User ID", '<>%1', UserId());
                    IF SessionG.FindSet() then
                        repeat
                            StopSession(SessionG."Session ID");
                        until SessionG.Next() = 0;
                end;

            }
        }
    }
    var
        SessionG: Record "Active Session";
        SelectedSessionChainQst: Label 'Do you want to kill the selected %1 session chain?';
        SelectedSessionQst: Label 'Do you want to kill the selected %1 session?';
        AllSessionQst: Label 'Do you want to kill all the session?';
}