from pathlib import Path
import tornado.ioloop
import tornado.web

from mathw import MathWork
from config import FILE_CACHE_NAME, FRONT_PATH


class MainHandler(tornado.web.RequestHandler):

    def set_default_headers(self):
        self.set_header("Content-Type", "application/json")
        self.set_header("Access-Control-Allow-Origin", "*")
        self.set_header("Access-Control-Allow-Headers", "content-type")
        self.set_header('Access-Control-Allow-Methods', 'POST, GET, OPTIONS, PATCH, PUT')
        # HEADERS!
        self.set_header("Access-Control-Allow-Headers", "access-control-allow-origin,authorization,content-type")

    def options(self, *args):
        self.set_status(204)
        self.finish()

    @staticmethod
    def get_file_path(series, level):
        path = FRONT_PATH + FILE_CACHE_NAME + '/'
        file_name = 'math_homework_{}_{}.pdf'.format(series, level)
        return path + file_name

    def get(self):
        series = self.get_argument('series')
        level = self.get_argument('level')
        MathWork(series=series.capitalize(),
                 level=level,
                 outputName=self.get_file_path(series, level)).go()
        self.finish({'status': 1})


def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
    ])


def init_cache_folder():
    p = Path(FRONT_PATH)
    if not p.exists():
        raise NotADirectoryError("\"{}\" not exist. "
                                 "Build frontend first.".format(p))
    c = p / FILE_CACHE_NAME
    if not c.exists():
        c.mkdir()

# web page server:
# serve -s build


if __name__ == "__main__":
    init_cache_folder()
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()
