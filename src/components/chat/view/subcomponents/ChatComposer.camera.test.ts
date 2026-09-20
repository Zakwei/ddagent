import test from 'node:test';
import assert from 'node:assert/strict';

test('camera input change invokes onAttachFiles with selected files and resets input value', () => {
  let attached: File[] = [];
  const fakeFile = { name: 'photo.jpg', size: 1024, type: 'image/jpeg' } as File;
  const onAttachFiles = (files: File[]) => {
    attached = files;
  };

  const inputElement = { value: 'C:\\fakepath\\photo.jpg' };
  const event = {
    target: {
      files: [fakeFile],
    },
  };

  // Simulates handleCameraChange logic in ChatComposer
  const handleCameraChange = (
    ev: { target: { files: File[] | null } },
    inputRef: { value: string } | null,
    onAttach?: (files: File[]) => void,
  ) => {
    const files = ev.target.files ? Array.from(ev.target.files) : [];
    if (files.length > 0) {
      onAttach?.(files);
    }
    if (inputRef) {
      inputRef.value = '';
    }
  };

  handleCameraChange(event, inputElement, onAttachFiles);

  assert.equal(attached.length, 1);
  assert.equal(attached[0], fakeFile);
  assert.equal(inputElement.value, '');
});

test('camera input change ignores empty file list and still resets input value', () => {
  let called = false;
  const onAttachFiles = () => {
    called = true;
  };

  const inputElement = { value: 'C:\\fakepath\\photo.jpg' };
  const event = {
    target: {
      files: [] as File[],
    },
  };

  const handleCameraChange = (
    ev: { target: { files: File[] | null } },
    inputRef: { value: string } | null,
    onAttach?: (files: File[]) => void,
  ) => {
    const files = ev.target.files ? Array.from(ev.target.files) : [];
    if (files.length > 0) {
      onAttach?.(files);
    }
    if (inputRef) {
      inputRef.value = '';
    }
  };

  handleCameraChange(event, inputElement, onAttachFiles);

  assert.equal(called, false);
  assert.equal(inputElement.value, '');
});
