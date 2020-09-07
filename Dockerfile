# this might be a good catch all image to use?

FROM jupyter/scipy-notebook:76402a27fd13

# below comes from here: https://mybinder.readthedocs.io/en/latest/tutorials/dockerfile.html#preparing-your-dockerfile
# put the notebooks in the directory tmp for future use as an image for a jupterhub

USER root
RUN mkdir ${HOME}/notebooks && mkdir ${HOME}/data
COPY notebooks/* ${HOME}/notebooks/
COPY data/* ${HOME}/data/
COPY environment.txt ${HOME}
COPY requirements.txt ${HOME}
RUN chown -R ${NB_UID} ${HOME}
RUN chown -R ${NB_UID} ${HOME}/notebooks
RUN chown -R ${NB_UID} ${HOME}/data
USER ${NB_USER}

# then we do a conda install of python dependencies
# mybinder must do something clever here with the ENTRYPOINT or a START script because getting a docker to initiate
# and activate the conda environment is not something I know how to do. So I'll split the YAML into two txt files,
# one for conda (well mamba because it is faster) and one for pypi

RUN conda update -n base conda
RUN conda install --quiet --yes -c conda-forge mamba
RUN mamba install --quiet --yes -c conda-forge --file environment.txt
RUN pip install -r requirements.txt