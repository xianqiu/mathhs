from run import MainHandler
from mathw import MathWork


def _refresh(series, max_level):
    for level in range(1, max_level + 1):
        MathWork(series=series,
                 level=level,
                 outputName=MainHandler.get_file_path(series.casefold(), level)).go()


def refresh_all():
    from mathw.series.add import MAX_LEVEL as MAX_LEVEL_ADD
    from mathw.series.mult import MAX_LEVEL as MAX_LEVEL_MULT
    _refresh('Add', MAX_LEVEL_ADD)
    _refresh('Mult', MAX_LEVEL_MULT)


if __name__ == '__main__':
    refresh_all()
