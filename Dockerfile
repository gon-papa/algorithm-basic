FROM jupyter/base-notebook:x86_64-latest

SHELL ["/bin/bash", "-c"]

WORKDIR /app/work

RUN pip install --upgrade pip \
    && pip install poetry

# 必要なファイルのコピー
# COPY ./pyproject.toml /app/work/pyproject.toml
# COPY ./poetry.lock /app/work/poetry.lock

# 環境変数の設定
ENV MAKE_ENV=container

# Poetryの設定と依存関係のインストール
# RUN poetry config virtualenvs.create false && \
#     poetry install --no-interaction --no-root

# JupyterLabの設定ファイルを作成し、パスワード認証を無効にする
RUN mkdir -p ~/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/ && \
    echo '{"codeCellConfig": {"autoClosingBrackets": true, "matchBrackets": true}}' > ~/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings && \
    echo 'c.NotebookApp.token = ""' > ~/.jupyter/jupyter_notebook_config.py && \
    echo 'c.NotebookApp.password = ""' >> ~/.jupyter/jupyter_notebook_config.py

# ポートの公開
EXPOSE 8888

# コンテナ起動時にJupyterLabを起動
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--no-browser", "--NotebookApp.token=''"]