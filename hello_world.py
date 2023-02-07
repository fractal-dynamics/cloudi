#import sys
#sys.path.append('/nix/store/py6ff80g1jjlzrdrwq664rlfzim1y9dg-cloudi-2.0.5/lib/cloudi-2.0.5/api/python/')
import traceback
from cloudi import API, terminate_exception

class Task(object):
    def __init__(self):
        self.__api = API(0) # first/only thread == 0

    def run(self):
        try:
            self.__api.subscribe("hello_world/get",
                                 self.__hello_world)
            self.__api.poll()
        except terminate_exception:
            pass
        except:
            traceback.print_exc(file=sys.stderr)

    def __hello_world(self, request_type, name, pattern,
                      request_info, request,
                      timeout, priority, trans_id, pid):
        return b'Hello World!'

if __name__ == '__main__':
    assert API.thread_count() == 1
    task = Task()
    task.run()
