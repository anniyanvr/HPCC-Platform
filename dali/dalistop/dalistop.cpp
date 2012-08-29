/*##############################################################################

    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
############################################################################## */

#include "platform.h"
#include "jlib.hpp"
#include "jmisc.hpp"
#include "mpbase.hpp"
#include "mpcomm.hpp"
#include "daclient.hpp"


int main(int argc, char* argv[])
{
    InitModuleObjects();
    try {
        if (argc<2) {
            printf("usage: dalistop <server_ip:port> [/nowait]\n");
            printf("eg:  dalistop .                          -- stop dali server running locally\n");
            printf("     dalistop eq0001016                  -- stop dali server running remotely\n");
        }
        else {
            SocketEndpoint ep;
            ep.set(argv[1],DALI_SERVER_PORT);
            bool nowait = false;
            if (argc>=3)
                nowait = stricmp(argv[2],"/nowait")==0;
            printf("Stopping Dali Server on %s\n",argv[1]);
            startMPServer(0);
            Owned<IGroup> group = createIGroup(1,&ep); 
            Owned<ICommunicator> comm = createCommunicator(group);
            CMessageBuffer mb;
            int fn=-1;
            mb.append(fn);
            if (comm->verifyConnection(0,2000)) {
                comm->send(mb,0,MPTAG_DALI_COVEN_REQUEST,MP_ASYNC_SEND);
                if (nowait)
                    Sleep(1000);
                else
                    while (comm->verifyConnection(0,1000)) {
                        PROGLOG("Waiting for Dali Server to stop....");
                        Sleep(5000);
                    }
            }
            else
                PROGLOG("Dali not responding");
            stopMPServer();
        }
    }
    catch (IException *e) {
        pexception("Exception",e);
        stopMPServer();
    }
    releaseAtoms();
    return 0;
}

