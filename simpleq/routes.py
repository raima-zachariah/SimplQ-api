import connexion


from simpleq.controllers.health_controller import HealthController
from simpleq import util


health_controller = HealthController()


def live():
    return health_controller.live()


def ready():
    return health_controller.ready()