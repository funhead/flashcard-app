import os
from os.path import expanduser
from typing import Dict

from django.shortcuts import render

# Create your views here.
from rest_framework import serializers
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status, permissions
from rest_framework.decorators import permission_classes
from rest_framework_recursive.fields import RecursiveField

from fc_prod_serv.models import MediaFile, MediaFileType
from production.business.media_file_watcher import MediaFileWatcher
from production.business.models import Folder


@permission_classes((permissions.AllowAny, ))
class FolderView(APIView):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.media_file_types = {}  # type:Dict[int, MediaFileType]

    def get(self, request, *args, **kw):
        # Process any get params that you may need
        # If you don't need to process get params,
        # you can skip this part
        #get_arg1 = request.GET.get('arg1', None)
        #get_arg2 = request.GET.get('arg2', None)

        # Any URL parameters get passed in **kw
        root_folder = self.get_folder_model()
        serializer = FolderSerializer(root_folder)
        response = Response(serializer.data, status=status.HTTP_200_OK)
        return response

    def get_queryset(self):
        return self.get_folder_model()

    def get_folder_model(self):
        mfw = MediaFileWatcher()
        root_folder_path = os.path.join(expanduser('~'), 'Dev/Projects/flashcard-app/media')
        root_folder = mfw.load_files(root_folder_path, ["jpg"])
        mfts = MediaFileType.objects.all()
        for mft in mfts:
            self.media_file_types[mft.media_file_type_id] = mft
        self.replace_files(root_folder)
        return root_folder

    def replace_files(self, folder: Folder):
        if folder.files is not None:
            media_files = []
            for file in folder.files:
                mf = MediaFile()  # type:MediaFile
                mf.name = file.name
                mf.media_file_type = self.media_file_types[1]
                mf.path = file.path
                media_files.append(mf)
            folder.files = media_files
        for sub_folder in folder.child_folders:
            self.replace_files(sub_folder)





class MediaFileField(serializers.Field):

    def to_representation(self, value):
        return value.name

    def to_internal_value(self, data):
        mf = MediaFile()
        mf.name = data
        return mf


class FolderSerializer(serializers.Serializer):
    name = serializers.CharField()
    child_folders = serializers.ListField(child=RecursiveField())
    files = serializers.ListField(child=MediaFileField())

    # class Meta:
    #     model = Folder
    #     fields = ('name', 'child_folders')

