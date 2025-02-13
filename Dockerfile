FROM python:3.10-slim AS python-deps
RUN pip3 install -v pipenv
COPY Pipfile .
RUN PIPENV_SKIP_LOCK=1 \
    PIPENV_VENV_IN_PROJECT=1 \
    pipenv install --deploy

FROM python-deps AS runtime
RUN useradd --create-home appuser
WORKDIR /home/appuser
USER appuser
COPY --chown=appuser:appuser \
     --from=python-deps \
     /.venv \
     .venv
ENV PATH="/home/appuser/.venv/bin:$PATH"
COPY --chown=appuser:appuser \
     upload.py \
     .

ENTRYPOINT [ "python3", "./upload.py" ]
CMD [ "--help" ]
