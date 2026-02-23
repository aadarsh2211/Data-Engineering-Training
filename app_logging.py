import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
    )

logging.debug("This is debuggere")
logging.info("app started")
logging.warning("This is a warning")
logging.critical("Crictical")
logging.error("error occured")
