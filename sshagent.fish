setenv SSH_ENV $HOME/.ssh/environment
  
function sshagent
    echo "Initializing new SSH agent ..."
    ssh-agent -c | sed 's/^echo/#echo/' > $SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV
    . $SSH_ENV > /dev/null
    ssh-add
end
 
function test_identities
    ssh-add -l | grep "The agent has no identities" > /dev/null
    if [ $status -eq 0 ]
        ssh-add
    end
end

if [ -n "$SSH_AGENT_PID" ]
   ps -ef | grep $SSH_AGENT_PID | grep ssh-agent > /dev/null
   if [ $status -eq 0 ]
       test_identities
   end
else
       if [ -f $SSH_ENV ]
           . $SSH_ENV > /dev/null
       end
       ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent > /dev/null
       if [ $status -eq 0 ]
           test_identities
       end
end
